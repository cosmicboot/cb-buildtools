mod logging;
mod ffi;

use serde::{Deserialize, Serialize};
use log::{info, Level};


#[derive(Serialize, Deserialize)]
struct Address {
    street: String,
    city: String,
}

#[no_mangle]
pub extern "C" fn main() -> i32 {
    logging::init_with_level(Level::Info).unwrap();

    // this creates a new event, outside of any spans.
    info!("preparing to shave yaks");

    let mut vector = Vec::new();

    for i in 0..10 {
        info!("Hello, world: {}!\n", i);
        vector.push(i);
    }
    info!("{:#?}", vector);

    let address = Address {
        street: "10 Downing Street".to_owned(),
        city: "London".to_owned(),
    };

    // Serialize it to a JSON string.
    let j = serde_json::to_string(&address).unwrap();

    // Print, write to a file, or send to an HTTP server.
    info!("{:#?}", j);

    // Serialize it to a YAML string.
    let y = serde_yaml::to_string(&address).unwrap();

    // Print, write to a file, or send to an HTTP server.
    info!("{:#?}", y);

    return 123;
}
