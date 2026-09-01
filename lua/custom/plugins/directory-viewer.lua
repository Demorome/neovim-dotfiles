-- Switched away from Oil.nvim for these reasons:
-- 1) It opens buffers, which messes with Ctrl+o history.
-- 2) When doing `:restart`, it messes the file's current type to be an Oil buffer (bug).
--
-- NOTE: mini.files does not support SSH, unlike Oil!
require('mini.files').setup()
