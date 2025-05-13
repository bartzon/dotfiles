-- This file is kept for backward compatibility
-- Autocmds have been moved to lua/user/autocmds/

-- Load all autocmds through the new structure
require('user.autocmds').setup()