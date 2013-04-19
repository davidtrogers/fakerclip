## Fakerclip

### Fake S3 on your filesystem for Paperclip.

This is a Rails Engine that helps simulate writing and reading from S3, by using your filesystem as a Fake S3.

Instead of this:
``` ruby
PATH_CONFIG = if App.use_s3_for_this_environment
  { url: 'is/my/s3/path', s3_bucket: 's3-foo-bar-bucket' }
else
  { path: 'is/my/local/path'}
end

has_attachment :foobar, DEFAULT_PAPERCLIP_CONFIG.merge(PATH_CONFIG)

```
do this:
``` ruby
PATH_CONFIG = { url: 'is/my/s3/path', s3_bucket: 's3-foo-bar-bucket' }

has_attachment :foobar, DEFAULT_PAPERCLIP_CONFIG.merge(PATH_CONFIG)
```

You should be able to write one config per paperclip attachment, specify the S3 bucket/folder setup, and be done with it.

With FakerClip, your filesystem is treated as an s3 bucket so you don't have to wonder if the changes you made to your s3 bucket configuration will break in production.  The idea is, if it didn't work on your local filesystem on development or test environments, it won't work on S3!

### Setup

``` ruby
gem 'fakerclip'
```

That's it!  Now, just omit `: { path: 'is/my/local/path' }` from the example above and expect that your files will appear in `"#{Rails.root}/public/fakerclip/(development|test)/s3-foo-bar-bucket/"` with the same structure as you would expect on S3, e.g. `is/my/s3/path` from above.

You can use either/both the fog and the aws-sdk gems as the client for S3

### Development

``` shell
bundle exec rake app:db:migrate app:db:test:prepare
bundle exec rspec
```
