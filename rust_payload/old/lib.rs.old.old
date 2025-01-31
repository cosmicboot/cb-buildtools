use std::{
    future::Future,
    pin::Pin,
    task::{Context, Poll},
};

use simple_async_local_executor::Executor;

extern "C" {
    pub fn env_print(s: *const u8, len: usize);
    pub fn env_ping();
}

fn print(s: &str) {
    unsafe {
        env_print(s.as_ptr(), s.len());
    }
}

#[derive(Debug)]
pub struct Keyboard {
    value: i32,
}

impl Keyboard {
    pub fn new(value: i32) -> Keyboard {
        Keyboard { value }
    }

    pub fn poll(&mut self, cx: &mut Context<'_>) -> Poll<()> {
        if self.value > 0 {
            self.value -= 1;
            Poll::Pending
        } else {
            Poll::Ready(())
        }
    }
}

#[derive(Debug)]
pub struct DelayedValue<T: Copy> {
    value: T,
    sleep: Keyboard,
}

impl<T: Copy> DelayedValue<T> {
    pub fn new(value: T, sleep: Keyboard) -> DelayedValue<T> {
        DelayedValue { value, sleep }
    }
}

impl<T: Copy> Future for DelayedValue<T> {
    type Output = T;

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output> {
        let x = self.value;
        let mut s = unsafe { self.map_unchecked_mut(|s| &mut s.sleep) };

        match &mut s.poll(cx) {
            Poll::Ready(()) => Poll::Ready(x),
            Poll::Pending => Poll::Pending,
        }
    }
}

#[no_mangle]
pub extern "C" fn main() {
    unsafe {
        env_ping();
    }
    print("Hello from Rust!");
    let executor = Executor::default();
    
    let sleep_1 = Keyboard::new(3);
    let delayed_value_1 = DelayedValue::new(42, sleep_1);
    let sleep_2 = Keyboard::new(3);
    let delayed_value_2 = DelayedValue::new(42, sleep_2);
    executor.spawn(async {
        let (value_1, value_2) = (delayed_value_1.await, delayed_value_2.await);
        print(&format!("{}, {}", value_1, value_2));
    });

    
    loop {
        let more_tasks = executor.step();
        if !more_tasks {
            break;
        }   
    }
}
