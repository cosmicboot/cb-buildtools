mod asyncio;
mod ffi;
mod logging;
mod panic;
mod lwip_error;

use std::net::Ipv4Addr;

use asyncio::{get_keypress, sleep_ms, tcp::TcpSocket};
use log::info;
use logging::init_with_level;
use simple_async_local_executor::Executor;



#[no_mangle]
pub extern "C" fn main() {
    panic::set_once();
    init_with_level(log::Level::Info).unwrap();
    let executor = Executor::default();


    executor.spawn(async {
        let setup_result = unsafe { ffi::env_setup_network() };
        if setup_result != 0 {
            log::error!("Failed to setup network: {}", setup_result);
            return;
        }

        let socket = TcpSocket::connect("192.168.1.120", 8080).await;

        if socket.is_err() {
            log::error!("Failed to connect to server: {}", socket.err().unwrap());
            return;
        }

        log::info!("Connected to server");
    });

    // executor.spawn(async {
    //     log::info!("Awaiting keypress B");
    //     let key = get_keypress().await;
    //     log::info!("Key pressed: {}", key);
    // });

    loop {
        let more_tasks = executor.step();
        if !more_tasks {
            break;
        }
    }
}
