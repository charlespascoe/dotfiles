// Vim Commands //

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
  // Not sure why "exec normal" doesn't work
  (api) => api.evaluateInPlugin('call feedkeys("\\<Esc>\\<C-i>")'),
);

vim.command(
  'window left',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>h"'),
);

vim.command(
  'window down',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>j"'),
);

vim.command(
  'window up',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>k"'),
);

vim.command(
  'window right',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>l"'),
);

vim.command(
  'swap window left',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>H"'),
);

vim.command(
  'swap window down',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>J"'),
);

vim.command(
  'swap window up',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>K"'),
);

vim.command(
  'swap window right',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>L"'),
);

vim.command(
  'window zoom',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>z"'),
);

vim.command(
  'normalise windows',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>="'),
);

vim.command(
  'switch',
  (api) => api.evaluateInPlugin('exec "normal \\<C-w>\\<C-w>"'),
);

vim.command(
  'top',
  (api) => api.evaluateInPlugin('normal zt'),
);

vim.command(
  'center',
  (api) => api.evaluateInPlugin('normal zz'),
);

vim.command(
  'bottom',
  (api) => api.evaluateInPlugin('normal zb'),
);

vim.command(
  'high',
  (api) => api.evaluateInPlugin('normal H'),
);

vim.command(
  'middle',
  (api) => api.evaluateInPlugin('normal M'),
);

vim.command(
  'low',
  (api) => api.evaluateInPlugin('normal L'),
);

vim.command(
  'next',
  // Executes custom UltiSnips jump command
  (api) => api.evaluateInPlugin('call feedkeys("\\<C-l>")'),
);

vim.command(
  'search <%name%>',
  // Opens up Ctrl-P and performs a fuzzy search based on the input
  (api, matched) => api.evaluateInPlugin(`call feedkeys("\\<Esc> o${matched.name}")`),
);

vim.command(
  'turn on spelling',
  (api) => api.evaluateInPlugin('set spell'),
);

vim.command(
  'turn off spelling',
  (api) => api.evaluateInPlugin('set nospell'),
);

vim.command(
  'close',
  (api) => api.evaluateInPlugin('q'),
  {autoExecute: false},
);

vim.command(
  'close file',
  // Note that this uses a plugin to change the other delete behaviour; see
  // https://github.com/moll/vim-bbye, or just change this to 'bdelete'
  (api) => api.evaluateInPlugin('Bdelete'),
  {autoExecute: false},
);

vim.command(
  'exit',
  // Note that this is a custom mapping; you could just use ZZ
  (api) => api.evaluateInPlugin('normal ZX'),
  {autoExecute: false},
);

// Go Commands //

const go = serenade.language('go');

go.command(
  'add method <%name%>',
  (api, matches) => {
    api.evaluateInPlugin(`call feedkeys("\\<Esc>i\\<Enter>m ")`);
    api.evaluateInPlugin(`call feedkeys("${matches.name}")`);
  },
);

// JavaScript Commands //

const javascript = serenade.language('javascript');

javascript.command('preview', async (api) => {
  await api.runCommand('save');
  await api.focusApplication('chrome');
  await api.runCommand('reload');
});

javascript.snippet(
  'add element <%identifier%>',
  '<%identifier%>()(<%cursor%>)',
  { 'identifier': ['camel'] },
  'inline',
);

javascript.snippet(
  'object',
  '{<%cursor%>}',
  {},
  'inline',
);
