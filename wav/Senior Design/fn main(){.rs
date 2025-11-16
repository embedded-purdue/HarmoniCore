fn main(){
    let mut a: Option<usize> = None;
    let mut b: Option<usize> = None;
    a = b; // This line will cause a compilation error due to type mismatch
    swap(&mut a, &mut b);
    println!("Hello, world!");


}

fn swap(&mut a: &mut usize, b: &mut usize) {
    let temp = *b;
    *a = Some(0);
    *b = Some(1);

    if let Some(a_inner) = a else {pannic!()};
}