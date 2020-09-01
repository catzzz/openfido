from app.models import db


def test_make_permission_decorator_no_auth(client, pipeline):
    result = client.get(
        f"/v1/pipelines/{pipeline.uuid}",
        content_type="application/json",
    )
    assert result.status_code == 401


def test_make_permission_decorator_empty_bearer(client, pipeline, client_application):
    db.session.commit()
    result = client.get(
        f"/v1/pipelines/{pipeline.uuid}",
        content_type="application/json",
        headers={"Workflow-Key": ""},
    )
    assert result.status_code == 401


def test_make_permission_decorator_bad_bearer(client, pipeline, client_application):
    db.session.commit()
    result = client.get(
        f"/v1/pipelines/{pipeline.uuid}",
        content_type="application/json",
        headers={"Workflow-Key": "bad"},
    )
    assert result.status_code == 401


def test_make_permission_decorator_success(client, pipeline, client_application):
    db.session.commit()
    result = client.get(
        f"/v1/pipelines/{pipeline.uuid}",
        content_type="application/json",
        headers={"Workflow-Key": client_application.api_key},
    )
    assert result.status_code == 200
