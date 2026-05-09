package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

func readYAML(path string) (map[string]any, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var out map[string]any
	if err := yaml.Unmarshal(data, &out); err != nil {
		return nil, fmt.Errorf("parse %s: %w", path, err)
	}
	return out, nil
}

func readJSON(path string) (map[string]any, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var out map[string]any
	if err := json.Unmarshal(data, &out); err != nil {
		return nil, fmt.Errorf("parse %s: %w", path, err)
	}
	return out, nil
}

func writeJSON(path string, data any) error {
	out, err := json.MarshalIndent(data, "", "    ")
	if err != nil {
		return err
	}
	return os.WriteFile(path, append(out, '\n'), 0o644)
}

// convertFrom wraps the "modifiers" value in a {"mandatory": ...} map;
// all other keys are passed through unchanged.
func convertFrom(fr map[string]any) map[string]any {
	out := make(map[string]any, len(fr))
	for k, v := range fr {
		if k == "modifiers" {
			out[k] = map[string]any{"mandatory": v}
		} else {
			out[k] = v
		}
	}
	return out
}

// convertConditions handles two forms:
//   - a list (passed through as-is)
//   - a map of type -> bundle_identifiers (expanded into a list of condition objects)
func convertConditions(cond any) []any {
	if list, ok := cond.([]any); ok {
		return list
	}
	m, ok := cond.(map[string]any)
	if !ok {
		return nil
	}
	var out []any
	for typ, bunIDs := range m {
		out = append(out, map[string]any{
			"type":               typ,
			"bundle_identifiers": bunIDs,
		})
	}
	return out
}

func convertRule(rule map[string]any) map[string]any {
	from, _ := rule["from"].(map[string]any)
	m := map[string]any{
		"type": "basic",
		"from": convertFrom(from),
	}

	if cond, ok := rule["conditions"]; ok {
		m["conditions"] = convertConditions(cond)
	}

	for k, v := range rule {
		if (k == "to" || strings.HasPrefix(k, "to_")) && m[k] == nil {
			m[k] = v
		}
	}

	return map[string]any{
		"description":  rule["desc"],
		"manipulators": []any{m},
	}
}

func convert(obj map[string]any) ([]any, error) {
	rawRules, ok := obj["rules"].([]any)
	if !ok {
		return nil, fmt.Errorf("expected 'rules' to be a list")
	}
	var out []any
	for _, r := range rawRules {
		rule, ok := r.(map[string]any)
		if !ok {
			return nil, fmt.Errorf("expected rule to be a map, got %T", r)
		}
		out = append(out, convertRule(rule))
	}
	return out, nil
}

func run() error {
	exe, err := os.Executable()
	if err != nil {
		return fmt.Errorf("resolve executable path: %w", err)
	}
	configsDir := filepath.Dir(exe)

	entries, err := os.ReadDir(configsDir)
	if err != nil {
		return fmt.Errorf("read dir %s: %w", configsDir, err)
	}

	// os.ReadDir returns entries sorted by name, but sort explicitly to match
	// the Python behaviour.
	sort.Slice(entries, func(i, j int) bool {
		return entries[i].Name() < entries[j].Name()
	})

	var rules []any
	for _, e := range entries {
		if !strings.HasSuffix(e.Name(), "karabiner.yml") {
			continue
		}
		path := filepath.Join(configsDir, e.Name())
		fmt.Println(path)

		obj, err := readYAML(path)
		if err != nil {
			return err
		}
		converted, err := convert(obj)
		if err != nil {
			return fmt.Errorf("%s: %w", path, err)
		}
		rules = append(rules, converted...)
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("resolve home dir: %w", err)
	}
	karabinerPath := filepath.Join(home, ".config", "karabiner", "karabiner.json")

	cfg, err := readJSON(karabinerPath)
	if err != nil {
		return fmt.Errorf("read karabiner config: %w", err)
	}

	profiles, _ := cfg["profiles"].([]any)
	if len(profiles) == 0 {
		return fmt.Errorf("no profiles in %s", karabinerPath)
	}
	profile, _ := profiles[0].(map[string]any)
	complexMods, _ := profile["complex_modifications"].(map[string]any)
	if complexMods == nil {
		return fmt.Errorf("no complex_modifications in first profile")
	}
	complexMods["rules"] = rules

	if err := writeJSON(karabinerPath, cfg); err != nil {
		return fmt.Errorf("write karabiner config: %w", err)
	}

	return nil
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}
