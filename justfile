_build-tool := if path_exists("pyproject.toml") == "true" {
    if read("pyproject.toml") =~ "poetry.core.masonry.api" {
        "poetry"
    } else if read("pyproject.toml") =~ "uv_build" {
        "uv"
    } else {
        ""
    }
} else {
    ""
}

setup:
    @if [[ "{{_build-tool}}" == "poetry" ]]; then poetry install; \
        elif [[ "{{_build-tool}}" == "uv" ]]; then uv sync; fi

run *args:
    @if [[ "{{_build-tool}}" == "poetry" ]]; then poetry run {{args}}; \
        elif [[ "{{_build-tool}}" == "uv" ]]; then uv run {{args}}; fi

vim *args:
    @if [[ "{{_build-tool}}" != "" ]]; then just --global-justfile run nvim {{args}}; \
        else nvim {{args}}; fi
