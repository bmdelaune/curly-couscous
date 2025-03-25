# README

## Things I would complete if I had time:
1. Wayyy more specs. I did not test negative cases or even write a system spec.
2. I would reduce the dependency on the `lib/open_mateo.rb` file and make it more of an adapter pattern.
3. I wouldn't be including `ActiveModel::API` everywhere for convenience
4. Do more error handling, especially with the OpenMateo API
5. Actually allow a full address input. Probably as simple as adding the fields to the form.

## To install
Ruby and bun versions stored in `.tool-versions`. You can use [`mise-en-place`]() to manage versions.
1. Install `ruby`
2. Install `bun`
3. Run `bundle install`
4. Run `bun run build`
5. Run `bundle exec rails server -p 3000`
6. Go to `http://localhost:3000/`

## To run specs
`bundle exec rspec spec/`

