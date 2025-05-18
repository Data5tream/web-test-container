# Build app
FROM rust:1.87-bookworm AS app-builder

WORKDIR /app
COPY Cargo.toml Cargo.lock /app/
COPY src /app/src/
RUN cargo build --release

# Build healthcheck
FROM rust:1.87-bookworm AS healthcheck-builder

RUN cargo install simple-web-healthcheck

# Copy the binary to distroless
FROM gcr.io/distroless/cc-debian12
COPY --from=healthcheck-builder /usr/local/cargo/bin/simple-web-healthcheck /healthcheck
COPY --from=app-builder /app/target/release/web-test-container /

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=1s CMD ["/healthcheck", "http://127.0.0.1:8080/ping"]

CMD ["/web-test-container"]
