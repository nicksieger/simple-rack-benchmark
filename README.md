This is an Apache JMeter-based request benchmark of a trivial Rack
application running on four JRuby-based servers, [Aspen][], [Kirk][],
[Trinidad][] and [Mizuno][].

Using JMeter on a separate machine on the local network, my MacBook
Pro 2.53Ghz Core 2 Duo produced the following results:

![requests](https://github.com/nicksieger/simple-rack-benchmark/raw/master/data/Requests.png)

## Reproducing the Benchmark

1. [Install JRuby](http://www.jruby.org/getting-started).
2. `gem install bundler`.
3. `bundle install`.
4. `./start.sh <server>` for each server you want to benchmark.
5. [Get JMeter](http://jakarta.apache.org/site/downloads/downloads_jmeter.cgi), start it up,
   and open the `srack.jmx` file.
6. (Optional) Start Visual VM and connect to the server to monitor
   memory, threads and CPU while the benchmark runs.
7. Start the benchmark with the "Run => Start" menu command.
8. Watch the benchmark in progress by selecting the "Summary Report"
   item in the tree.

Submit your benchmark results as [issues in the issue tracker][issues]!

[Aspen]: https://github.com/kevwil/aspen
[Kirk]: https://github.com/strobecorp/kirk
[Trinidad]: https://github.com/calavera/trinidad
[Mizuno]: https://github.com/matadon/mizuno
[issues]: https://github.com/simple-rack-benchmark/issues
