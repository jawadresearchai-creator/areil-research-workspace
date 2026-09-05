# Parallelism & Context
Use workers for independent information gain, not decorative swarms. Give each worker claim IDs and an output schema. Workers write findings to files/structured outputs. Keep integration sequential. Stop spawning when findings become redundant.
