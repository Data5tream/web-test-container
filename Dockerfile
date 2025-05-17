# Build app
FROM rust:1.87-bookworm AS app-builder

WORKDIR /app
COPY Cargo.toml Cargo.lock /app/
COPY src /app/src/
RUN cargo build --release

# Build healthcheck
FROM rust:1.87-bookworm AS healthcheck-builder

WORKDIR /app
COPY healthcheck /app/
RUN cargo build --release

# Copy the binary to distroless
FROM gcr.io/distroless/cc-debian12
COPY --from=app-builder /app/target/release/web-test-container /
COPY --from=healthcheck-builder /app/target/release/healthcheck /

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=1s CMD ["/healthcheck"]

CMD ["/web-test-container"]
