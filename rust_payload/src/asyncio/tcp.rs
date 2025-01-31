use std::io;

use crate::ffi;

pub struct TcpStream {
    socket: i32,
}

// impl TcpStream {
//     pub async fn connect(addr: &str, port: u16) -> Result<Self, io::Error> {
//         let socket = unsafe { ffi::env_socket_create() };
//         if socket < 0 {
//             return Err(io::Error::last_os_error());
//         }

//         unsafe {
//             ffi::env_socket_connect(socket, addr.as_ptr(), port);
//         }

//         // Wait for connection
//         TcpConnect { socket }.await?;
        
//         Ok(Self { socket })
//     }

//     pub async fn read(&mut self, buf: &mut [u8]) -> Result<usize, io::Error> {
//         // Implementation for reading
//     }

//     pub async fn write(&mut self, buf: &[u8]) -> Result<usize, io::Error> {
//         // Implementation for writing
//     }
// }