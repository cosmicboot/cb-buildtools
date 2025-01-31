mod ffi;
mod logging;
mod panic;
mod asyncio;

use log::info;
use logging::init_with_level;
use asyncio::{get_keypress, sleep_ms};
use simple_async_local_executor::Executor;

#[no_mangle]
pub extern "C" fn main() {
    panic::set_once();
    init_with_level(log::Level::Info).unwrap();
    info!("Hello, world!");

    let executor = Executor::default();

    executor.spawn(async {
        // Sleep for 1 second
        for i in 0..10 {
            sleep_ms(1000).await;
            log::info!("Index {}", i);
        }
        //     // Connect to TCP server
        //     // let mut stream = TcpStream::connect("127.0.0.1", 8080).await.unwrap();

        //     // Write some data
        //     // stream.write(b"Hello").await.unwrap();
    });

    executor.spawn(async {
        log::info!("Awaiting keypress B");
        let key = get_keypress().await;
        log::info!("Key pressed: {}", key);
    });

    loop {
        let more_tasks = executor.step();
        if !more_tasks {
            break;
        }
    }
}
