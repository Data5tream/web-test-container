use std::{env, sync::LazyLock};

use actix_web::{App, HttpResponse, HttpServer, Responder, get, middleware::Logger};
use log::info;

static NAME: LazyLock<String> =
    LazyLock::new(|| env::var("CONTAINER_NAME").unwrap_or("WebTestContainer".to_string()));

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().body(format!("Hello from {}!", *NAME))
}

#[get("/ping")]
async fn ping() -> impl Responder {
    HttpResponse::Ok().body("pong")
}

#[get("/status/{code}")]
async fn status(code: actix_web::web::Path<u16>) -> impl Responder {
    let requested_status = code.into_inner();

    if requested_status > 599 {
        return HttpResponse::BadRequest().body("Status code must be between 0 and 599");
    }

    HttpResponse::build(actix_web::http::StatusCode::from_u16(requested_status).unwrap()).finish()
}

#[get("/headers")]
async fn headers(req: actix_web::HttpRequest) -> impl Responder {
    let headers = req
        .headers()
        .iter()
        .map(|(k, v)| format!("{}: {}", k.as_str(), v.to_str().unwrap()))
        .collect::<Vec<String>>()
        .join("\n");

    HttpResponse::Ok().body(headers)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let log_level = env::var("LOG_LEVEL").unwrap_or("info".to_string());

    env_logger::init_from_env(env_logger::Env::new().default_filter_or(&log_level));

    info!("Starting server with name: {}", *NAME);

    HttpServer::new(|| {
        App::new()
            .service(index)
            .service(ping)
            .service(status)
            .service(headers)
            .wrap(Logger::default())
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
