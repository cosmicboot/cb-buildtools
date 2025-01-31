unsafe extern "C" {
    // System
    pub fn env_now() -> u64;  // Get current timestamp
    pub fn env_print(s: *const u8, len: usize);  // Print string
    
    // Keyboard
    pub fn env_key_pressed() -> i32;  // Returns keycode or -1 if no key
    
    // Network
    pub fn env_setup_network() -> i32;
    pub fn env_socket_create() -> i32;
    pub fn env_socket_close(socket: i32) -> i32;
    pub fn env_socket_poll(socket: i32) -> i32;
    pub fn env_socket_connect(socket: i32, addr: *const u8, port: u16) -> i32;
    pub fn env_socket_check_connection(socket: i32) -> i32;
    pub fn env_socket_read(socket: i32, buf: *mut u8, len: usize) -> i32;
    pub fn env_socket_write(socket: i32, buf: *const u8, len: usize) -> i32;
}