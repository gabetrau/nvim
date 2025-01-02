local config = {
    cmd = {'/usr/local/jdtls/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['jdtls'].setup {
    capabilities = capabilities
}
