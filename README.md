# Ballchasing

[![Rubocop Status](https://github.com/jubishop/ballchasing/workflows/Rubocop/badge.svg)](https://github.com/jubishop/ballchasing/actions/workflows/rubocop.yml)

A Ruby library for the ballchasing.com API.

## Installation

### Global installation

```zsh
gem install ballchasing --source https://www.jubigems.org/
```

### In a Gemfile

```ruby
gem 'ballchasing', source: 'https://www.jubigems.org/'
```

## Usage

```ruby
require 'ballchasing'

# token param will default to ENV['BALLCHASING_TOKEN']
api = Ballchasing::API.new(token)

# Lets get the first 10 matches that are:
#   ranked-doubles matches,
#   with all grand-champions,
#   sorted from oldest first,
#   starting one day ago:
# All params from the /replays endpoint are supported.
# DateTime.rfc3339 is how to generate valid date params.
results = api.replays(
  'replay-date-after': (DateTime.now - 1).rfc3339,
  'sort-by': 'replay-date',
  'sort-dir': 'asc',
  'count': 10,
  'playlist': 'ranked-doubles',
  'min-rank': 'grand-champion')

# The results object itself implements Enumerable, so you can `.each` over
# it for every summary.
results.each { |summary|
  # You can see all the summary attributes in lib/objects/replay_summary.rb

  # If we want the details for any summary, it's inside `.replay`
  details = summary.replay

  # Check out lib/replay.rb to see all the detailed attributes available.

  # How much time did the orange team spend on the ground?
  puts details.orange.stats.movement.time_ground
}

# We can loop and continue to get the next chunk of replays from our query
# until we're out of results, like so:
until results.next.nil?
  results = results.next
  # Now we have our next chunk of results in `results`
end

# In each game, who was the fastest player?
fastest_players = results.map { |summary|
  (summary.replay.orange.players + summary.replay.blue.players).max { |a, b|
    a.stats.movement.avg_speed <=> b.stats.movement.avg_speed
  }
}
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
