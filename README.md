# hello-world-scratch-go-action

A template to demonstrate how to build a Go action from a scratch Docker image.

This template shows how to:

- Build a **static Go binary** packaged inside a `FROM scratch` container  
- Read **command-line arguments** provided through `with:`  
- Read **environment variables** provided through `env:`  
- Automatically scan all variables starting with `HELLO_*`  
- Write values to **GitHub Action outputs** using `$GITHUB_OUTPUT`  
- Provide a minimal and clean structure suitable for reuse

---

## 🚀 Usage Example

```yaml
steps:
  - uses: actions/checkout@v3

  - name: Run Hello World
    id: hello
    uses: localcompose/hello-world-scratch-go-action@v1

    # These become the container’s CLI arguments
    with:
        preposition: "of"
        noun: "Args"

    # These become environment variables inside the container
    env:
      HELLO_WORLD: "The world of env"
      HELLO_EXTRA: "Extra env"

  - name: Show outputs
    run: |
      echo "Args output: ${{ steps.hello.outputs.argsOutput }}"
      echo "HELLO_WORLD output: ${{ steps.hello.outputs.envOutput }}"
