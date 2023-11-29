FROM python:3.8 as base


ENV CELERY_BROKER_URL redis://redis:6379/0
ENV CELERY_RESULT_BACKEND redis://redis:6379/0
ENV C_FORCE_ROOT true

RUN pip install poetry

RUN poetry config virtualenvs.create false
RUN poetry config installer.max-workers 1

WORKDIR /code
COPY . .


FROM base as api
ENV HOST 0.0.0.0
ENV PORT 5001
ENV DEBUG true



RUN make install-api


EXPOSE $PORT

FROM base as worker


RUN make install-worker

CMD poetry run watchmedo auto-restart --directory=./ --pattern=*.py --recursive -- celery -A tasks worker --concurrency=1 --loglevel=INFO -E
