# Shiftcare Technical Challenge

## Installation
```sh
gem install bundler
bundle install
```

## Usage
The two commands are implemented using `Rake` (see notes below)

### Finding clients that match a given query string
```sh
rake clients:find_matches [query] [field - optional] [data_path - optional]
```
e.g.
```sh
rake clients:find_matches Isabella
rake clients:find_matches Isabella full_name
rake clients:find_matches fastmail.fm email
rake clients:find_matches fastmail.fm email clients.json
```

Note that the query string supports regex e.g.
```sh
rake clients:find_matches "I.*Rodriguez"
```

### Finding clients with duplicate emails
```sh
rake clients:find_duplicates [field - optional] [data_path - optional]
```

e.g.
```sh
rake clients:find_duplicates
rake clients:find_duplicates email
rake clients:find_duplicates full_name
rake clients:find_duplicates email clients.json
```

## Notes

- I typically tackle software development in two phases. The first goal is to deliver a minimal prototype which demonstrates that the basic functionality is possible. This allows me to identify any areas where the requirements are unclear, and get feedback from stakeholders that I'm building what they expect. After that, I shift gear into a more test-driven approach to provide a more maintainable architecture, develop the UI, handle errors, and so forth. You'll see these two phases reflected in the commit history.
- I've chosen to use `Rake` as a task runner, as it's the most widely-used gem for calling Ruby from the command line (https://www.ruby-toolbox.com/categories/scripting_frameworks). If this were regular work, I'd first make sure I had a clear idea of what's meant by the term "application" in the specification. Depending on where the code is expected to run and by whom, it might be more appropriate to use `Thor`, custom code, or some other system to wrap the Ruby code.
- I've deliberately separated the Rake-specific code in `Rakefile` from the service classes that perform the required actions, and the underlying classes in `lib/`. If we wanted to use something other than Rake, this minimises the amount of code that needs to change.
- `Rake` by default uses an unconventional format for command line arguments, so I've adopted a common technique to support something more typical.
- I've provided two classes `Client` and `ClientList` with the core code. I try to be careful with names, and in a real working environment I'd want to check whether these names are consistent with terms used elsewhere in the business, and whether they're likely to clash with other concepts. For example, if we were later to integrate with third-party services, we might expect to write an API "client". In practice it's hard to avoid some degree of duplication in terms, but I like to do what I can to avoid it where possible.
- I've allowed `ClientList` to raise some errors directly from lower-level libraries where I felt the error messages were clear enough without modification. In a real project I'd consider wrapping these in custom errors (as I've used in `Client`) to provide more context.
- There are two service classes `FindDuplicates` and `FindMatches` which act something like controller actions for each command: they're responsible for building a `ClientList`, calling the appropriate method on it, and reporting the results.
- I've chosen `RSpec` for testing. `MiniTest` would also have been a good option (and in fact it's now slightly more widely used than RSpec: https://www.ruby-toolbox.com/categories/testing_frameworks). For projects with entirely new code I don't think there's any particular reason to prefer RSpec. However, I find it really shines in real-world projects where there's legacy code that wasn't written with automated testing in mind. I've used it here to illustrate my usual style for unit testing, using a `describe` block for each public method.

## Next Steps

### Specifying JSON file and search field
- I've gone ahead and implemented the first bullet point from Next Steps in the main branch, as it seemed a natural extension of the base functionality. Both commands accept optional arguments for a search field and source file. For real work I'd discuss this with a Product Owner or similar stakeholder before proceeding.
- A limitation of the approach I've taken with Rake is that arguments are positional: if you want to provide a third argument you can't skip the second. I've assumed that this would be an acceptable limitation, but if necessary it could be corrected by changing to another way of receiving command line arguments, without changing any of the other code.

### Providing a REST API
- I've implemented this in a separate `rails` branch, with a Github pull request ready to merge at https://github.com/isaacfreeman/shiftcare-technical-challenge/pull/1
- I've chosen to use `Rails` as the web framework. Arguably for a simple job like this it might have been appropriate to use a lighter-weight framework such as `Sinatra`. However, I felt Rails would probably be more familair to Shiftcare (as it is to me), and using it might facilitate some further conversations.
- I've implemented the endpoint as specified: `http://localhost:3000/query?q=foo`. In a real project, I'd want to discuss whether this is the best format for an API, and would probably recommend something like `/clients?q=foo` to be clear about what's being queried. If we built further on this we might wish to query other objects.
- I've also supported a `field` param.
- I've not implemented an API endpoint for the `find_duplicates`, as it wasn't specified. However, it would follow a similar pattern, as another action on `ClientsController`.
- At this stage I've left the data source unchanged, so that the app is retireving its clients from the `clients.json` file on every request. In a real web project I'd typically move this data to a database. Under that scenario I'd make `client.rb` a Rails model.
