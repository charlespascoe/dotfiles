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
