# ruby-json-transformer
A simple Ruby application useful to perform JSON-to-JSON transformation.

This simple application allows JSON-to-JSON transformations, receiving events from a source and sending results to a destination.

## Project structure

### Sources
In `sources` folder, there are source files for different sources; each `Source::` accepts a set of arguments in the initializer method and implements a `each_message` method where a block needs to be provided, where the message will be available as string.
These sources are currently supported:
- `Console`: reads from stdin, the message will be sent with `Enter key` and it will end at `Ctrl-c`
- `Kafka` (arguments: `url`, `topic`): reads messages from a Kafka topic


### Destinations
In `destinations` folder, there are source files for different destination; each `Destinations::` accepts a set of arguments in the initializer method and implements a `write_message` method where a string needs to be provided.
These destinations are currently supported:
- `Console`: write messages to stdout
- `Kafka` (arguments: `url`, `topic`): send messages to a Kafka topic

### Operations
In `operations` folder, there are source files for different operations; each `Operations::` accepts a set of arguments in the initializer method and implements a `operate` method where a JSON hash needs to be provided and another JSON hash will be returned.
Each operation supports `include_keys` and `exclude_keys` arguments; when both are present, only `include_keys` will be used. When neither of the two are present, all keys will be transformed.
These operations are currently supported:
- `flatten`: extract nested structured to root (`{ foo: { bar: { a: 1, b: 2 } }` -> `{ foo_bar_a: 1, foo_bar_a: 1, foo_bar_a: 1 }`
- `to_key_value_array`: each object data will be splitted to key and value arrays (`{ foo: { a: 1, b: 2 } }` -> `{ foo.key: ["a", "b"], foo.value: [1, 2] }`)
- `remove_keys`: remove specific keys from given object (`include_keys=['foo.b']`, `{ foo: { a: 1, b: 2 } }` -> `{ foo: { a: 1 } }`)
- `keep_keys`: keep only specific keys from given object (`include_keys=['foo', 'foo.b']`, `{ foo: { a: 1, b: 2 } }` -> `{ foo: { b: 2 } }`)

### Configuration
The `Configuration` class is responsible of parsing a JSON string containing the desidered spec for the application. Multiple configuration can be provided and the application will check for a JSON file describing those configurations; this file should be structured as follow:
```
[
  {
    "source": {
      "type": "console"
    },
    "operations": [
      {
        "type": "remove_keys",
        "keys": ["key1"]
      },
      {
        "type": "flatten"
      }
    ],
    "destination": {
      "type": "console"
    }
  },
  ...
]
```

### Multiple workers
Coming soon!
