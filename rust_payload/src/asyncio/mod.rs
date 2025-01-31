pub mod keyboard;
pub mod sleep;
pub mod tcp;

pub async fn sleep_ms(duration_ms: u64) {
    let sleep = sleep::Sleep::new(duration_ms);
    sleep.await;
}