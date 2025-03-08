# Build
FROM rust:1.85-bookworm AS rust-builder

WORKDIR /app
COPY Cargo.toml Cargo.lock /app/
COPY src /app/src/
RUN cargo build --release

# Copy the binary to distroless
FROM gcr.io/distroless/cc-debian12
COPY --from=rust-builder /app/target/release/web-test-container /

EXPOSE 8080

CMD ["/web-test-container"]
