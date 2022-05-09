/* Serenade Custom Commands

In this file, you can define your own custom commands with the Serenade API.

For instance, here's a custom automation that opens your terminal and runs a command:

serenade.global().command("make", api => {
  api.focusApplication("terminal");
  api.typeText("make clean && make");
  api.pressKey("return");
});

And, here's a Python snippet for creating a test method:

serenade.language("python").snippet(
  "test method <%identifier%>",
  "def test_<%identifier%>(self):<%newline%><%indent%>pass",
  { "identifier": ["underscores"] }
  "method"
);

For more information, check out the Serenade API documentation: https://serenade.ai/docs/api

*/

const vim = serenade.app('Vim');

vim.command(
  'split',
  (api) => api.evaluateInPlugin('vsplit'),
);

vim.command(
  'horizontal split',
  (api) => api.evaluateInPlugin('split'),
);

vim.command(
  'back',
  (api) => api.evaluateInPlugin('exec "normal \\<C-o>"'),
);

vim.command(
  'forward',
  (api) => api.evaluateInPlugin('exec "normal \\<C-i>"'),
);

vim.command(
  'normalise windows',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>="'),
);

vim.command(
  'close',
  (api) => api.evaluateInPlugin('q'),
  {autoExecute: false},
);

vim.command(
  'close file',
  (api) => api.evaluateInPlugin('Bdelete'),
  {autoExecute: false},
);
