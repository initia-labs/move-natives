# move-natives

Move standard libraries for Initia L1 and L2 chains.

## Libraries

| Directory | Description | Docs |
|-----------|-------------|------|
| `initia_stdlib` | Standard library for Initia L1 (account, cosmos, nft, staking, etc.) | [`doc/`](./initia_stdlib/doc/) |
| `minitia_stdlib` | Standard library for Minitia L2 rollups | [`doc/`](./minitia_stdlib/doc/) |
| `move_stdlib` | Base Move standard library (vector, string, option, etc.) | [`doc/`](./move_stdlib/doc/) |
| `move_nursery` | Experimental and incubating modules | [`doc/`](./move_nursery/doc/) |

## Usage

Add as a dependency in `Move.toml`:

```toml
[dependencies]
InitiaStdlib = { git = "https://github.com/initia-labs/move-natives.git", subdir = "initia_stdlib", rev = "main" }
```
