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

vim.command('first', async (api) => {
  await api.runCommand('start of line');
});

vim.command('end', async (api) => {
  await api.runCommand('end of line');
});

vim.command('line', async (api) => {
  await api.runCommand('add newline');
});

vim.command('line above', async (api) => {
  await api.runCommand('add newline above');
});

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
  (api) => api.evaluateInPlugin('normal *'),
);

vim.command(
  'previous',
  (api) => api.evaluateInPlugin('normal #'),
);

vim.command(
  'next match',
  (api) => api.evaluateInPlugin('normal n'),
);

vim.command(
  'previous match',
  (api) => api.evaluateInPlugin('normal N'),
);

vim.command(
  'opposite pair',
  (api) => api.evaluateInPlugin('normal %'),
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
  'trim',
  (api) => api.evaluateInPlugin('Trim'),
);

vim.command(
  'mark <%mark%>',
  (api, matched) => {
    if (matched.mark.length !== 1) {
      throw new Error('mark must be single character');
    }

    api.evaluateInPlugin(`normal m${matched.mark[0]}`);
  },
);

vim.command(
  'jump <%mark%>',
  (api, matched) => {
    if (matched.mark.length !== 1) {
      throw new Error('mark must be single character');
    }

    api.evaluateInPlugin(`normal \`${matched.mark[0]}`);
  },
);

vim.command(
  'edit snippets',
  (api) => api.evaluateInPlugin('UltiSnipsEdit'),
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

vim.command('tmux right', async (api) => {
  await api.pressKey('right', ['control', 'alt']);
});

vim.command('tmux left', async (api) => {
  await api.pressKey('left', ['control', 'alt']);
});

// Global Commands //

serenade.global().command('terminal', (api) => api.runCommand('focus alacritty'));

serenade.global().command('file start', async (api) => {
  await api.runCommand('top of file');
});

serenade.global().command('file end', async (api) => {
  await api.runCommand('end of file');
});

serenade.global().command('stop', async (api) => {
  await api.pressKey('c', ['control']);
});

serenade.global().command('restart', async (api) => {
  await api.pressKey('c', ['control']);
  await api.delay(100);
  await api.pressKey('up');
  await api.delay(100);
  await api.pressKey('enter');
});

// Go Commands //

const go = serenade.language('go');

go.command(
  'add method <%name%>',
  async (api, matches) => {
    api.evaluateInPlugin(`call feedkeys("\\<Esc>i\\<Enter>m ")`);
    await api.delay(100);
    api.evaluateInPlugin(`call feedkeys("${matches.name}")`);
  },
);

go.command('find references', (api) => {
  api.evaluateInPlugin('GoReferrers');
}, {chainable: 'firstOnly'});

go.command('go to test file', (api) => {
  api.evaluateInPlugin('GoAlternate!');
});

go.command('run tests', (api) => {
  api.evaluateInPlugin('wa | GoTest');
});

go.command('build', (api) => api.evaluateInPlugin('wa | GoBuild'));

// JavaScript Commands //

const javascript = serenade.language('javascript');

javascript.command('preview', async (api) => {
  await api.runCommand('save');
  await api.focusApplication('chrome');
  await api.runCommand('reload');
});

javascript.snippet(
  'add element <%identifier%>',
  '<%identifier%>()(<%cursor%>),',
  { 'identifier': ['camel'] },
  'inline',
);

javascript.snippet(
  'object',
  '{<%cursor%>}',
  {},
  'inline',
);
