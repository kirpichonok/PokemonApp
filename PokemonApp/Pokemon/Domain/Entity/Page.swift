struct Page {
    let number: Int

    init(number: Int) {
        self.number = abs(number)
    }
}
