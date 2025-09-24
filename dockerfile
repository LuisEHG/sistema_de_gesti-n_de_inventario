FROM python:3.10-slim AS builder

WORKDIR /app

COPY pyproject.toml setup.py ./
COPY inventory/ ./inventory/

RUN test -f README.md || echo "# Project README" > README.md

# Instala dependencias
RUN pip install --upgrade pip && \

    pip install --user .


FROM python:3.10-slim
WORKDIR /app

COPY --from=builder /root/.local /root/.local
COPY --from=builder /app/inventory ./inventory

ENV PATH=/root/.local/bin:$PATH
ENV FLASK_APP=inventory/app.py
ENV FLASK_ENV=production

EXPOSE 5000
CMD ["flask", "run", "--host=0.0.0.0"]
