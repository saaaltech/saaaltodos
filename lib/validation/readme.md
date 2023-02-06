# Why validation here rather than widget test?

Those widgets cannot work in testing environment, while when running the real
app, they all work normally. Perhaps there are bugs in flutter test tools, and
it is not solved till this commit.

Widgets here is this folder are only for validation propose. They should not be
included into the source code, otherwise, please place the corresponding file in
other places.
