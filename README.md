# build.bash

The `build.bash` script helps build Docker images and upload them to container registries. Reasons you might use this instead of the built-in Docker build job in your continuous integration system:

- Run the exact same build process locally as runs in the CI environment and produces production Docker images.
- No script modifications necessary, configure for different systems with environment variables.
- Builds for `develop` and `main` branches produce containers tagged with the branch name and pushed to container registries.
- Branches named in the format `release/x.y.z` are pushed to container registries with that container tag as well as the container tag `latest`.
- Other branches go through the `build` stage in the `Dockerfile` but not further (and no image is uploaded).
- Build environment information is brought in as container labels (Git commit id, build date, version) and you can easily add more.
- Can push to a configured container registry (Docker Hub by default) as well as the GitHub Container registry.

**You only need `build.bash`, the rest of this project is testing and examples.**

## Usage

### Running from the command line

`build.bash [-h] [-v] [-df Dockerfile] [-p] [Docker tag]`

Options (all are optional):

- `-h, --help` - Print this help and exit
- `-v, --verbose` - Print script debug info
- `-df, --dockerfile` - Use the specified Dockerfile
- `-p, --publish` - Run the release-publish.bash script in the container (if it's present)
- `Docker tag` - Override the guessed Docker tag (the current directory) with this value if present

Environment variables (all are optional):

- `BLD_DOCKER_IMAGE` - name of Docker image, uses directory name by default
- `CR_HOST` - hostname of the container registry, defaults Docker default (Docker Hub)
- `CR_OWNER` - owner of the container registry
- `CR_PASSWORD` - password to log into the container registry
- `CR_USER` - username to log in to the container registry
- `GHCR_OWNER` - owner of the GitHub Container Registry (defaults to `GHCR_USER`)
- `GHCR_PAT` - GitHub Container Registry Personal Access Token
- `GHCR_USER` - username to log in to the GitHub Container Registry

## Example configuration for continuous integration

### Pre-configuration

1. Get credentials for pushing containers into your desired registry or registries.

- GitHub [Personal Access Token for the GitHub Container Registry](https://docs.github.com/en/free-pro-team@latest/packages/guides/pushing-and-pulling-docker-images#authenticating-to-github-container-registry).
- Docker Hub [Personal Access Token](https://docs.docker.com/docker-hub/access-tokens/).
- Azure container registry [credentials](https://azure.microsoft.com/en-us/services/container-registry/).

#### Set up your Dockerfile

1. Use [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) and name your build stage `build`.
2. Bring in metadata with the `ARG` instruction for `BRANCH`, `IMAGE_CREATED`, `IMAGE_REVISION`, and `IMAGE_VERSION`.
3. Use those variables in your `LABEL` and `ENV` instructions.

See [this sample Dockerfile](https://github.com/mcld/buildscript/blob/main/Dockerfile) for more details. This `Dockerfile` is based on the one provided when creating a Microsoft Visual Studio Web Application with the "Enable Docker Support" box checked so you can use it both for Visual Studio Docker support as well as performing your builds if that's your environment.

#### Set up CI

- Configure secrets for your repository ([GitHub](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository), [Azure](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch)).

  - `BLD_DOCKER_IMAGE` can be set to the name of the Docker image if you like, if not it will use the directory name of your project.
  - `CR_HOST` - hostname of the container registry, defaults to Docker Hub.
  - `CR_OWNER` - container registry repository (username or organization).
  - `CR_PASSWORD` - container registration password or Personal Access Token.
  - `CR_USER` - container registry username for authentication.
  - `GHCR_OWNER` - GitHub Container Registry repository (username or organization name).
  - `GHCR_PAT` - GitHub Personal Access Token.
  - `GHCR_USER` - username associated with the GitHub Personal Access Token (for authentication).

- Review sample CI configurations:

  - [GitHub Action](https://github.com/mcld/buildscript/blob/main/.github/workflows/build.yml)
  - [Azure Pipeline](https://github.com/mcld/buildscript/blob/main/azure-pipelines.yml)

- Push some branches and open and resolve some PRs to see if the build works successfully.

## License

The build.bash script is [licensed](LICENSE.md) under the MIT License. A basis for the script is the MIT-licensed "Minimal safe Bash script template" by [Maciej Radzikowski](https://github.com/m-radzikowski).
