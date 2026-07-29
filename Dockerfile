FROM rust:1.85-bookworm AS compiler
RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev clang ca-certificates git && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 https://github.com/Noliae-France/nolc.git /opt/nolc && cargo install --path /opt/nolc
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=compiler /root/.cargo/bin/nolc /usr/local/bin/nolc
COPY --from=compiler /opt/nolc/lib "/Noliae Lang/lib"
WORKDIR /app
COPY main.nol accueil.nhtml ./
RUN nolc nhtml accueil.nhtml && nolc build main.nol -o nolcore --lien pq --chemin-lib /usr/lib/x86_64-linux-gnu
EXPOSE 8080
CMD ["/app/nolcore"]
