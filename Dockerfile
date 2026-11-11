FROM debian:bookworm-slim AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends g++ && \
    rm -rf /val/lib/apt/lists/*

WORKDIR /app

COPY main.cpp .

RUN g++ -std=c++17 main.cpp -o app

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/app .

CMD [ "./app" ]