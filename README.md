This is an Apache JMeter-based request benchmark of a trivial Rack
application running on four JRuby-based servers, [Aspen][], [Kirk][],
[Trinidad][] and [Mizuno][].

Using JMeter on a separate machine on the local network, my MacBook
Pro 2.53Ghz Core 2 Duo produced the following results (higher is
better).

![requests](https://github.com/nicksieger/simple-rack-benchmark/raw/master/data/Requests.png)

## Reproducing the Benchmark

1. [Install JRuby](http://www.jruby.org/getting-started).
2. Run `rake install` to install all server gems and JMeter.
3. Start JMeter with `rake jmeter`.
4. Start the server of your choice with `rake server[<server-name>]`.
5. (Optional) Start Visual VM and connect to the server to monitor
   memory, threads and CPU while the benchmark runs.
6. Start the benchmark with the "Run => Start" menu command.
7. Watch the benchmark in progress by selecting the "Summary Report"
   item in the tree.

*A side note*: if you're running JMeter on the same machine as
the server, the 200 concurrent users run might overwhelm your machine
and produce unreliable results. Pay attention to the error count --
any amount over 1-2% probably indicates either the server or your
computer is topping out.

Submit your benchmark results as [issues in the issue tracker][issues]!

[Aspen]: https://github.com/kevwil/aspen
[Kirk]: https://github.com/strobecorp/kirk
[Trinidad]: https://github.com/calavera/trinidad
[Mizuno]: https://github.com/matadon/mizuno
[issues]: https://github.com/simple-rack-benchmark/issues
