
# FileSystem::Helpers

Useful subs for interacting with the host filesystem.

* `copy-dir` recursively copies the content of directory
* `temp-dir` Accepts a block and runs it after defining `$*tmpdir`, deleting the temporary directory after block execution has finished.

