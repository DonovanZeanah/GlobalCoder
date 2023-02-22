rrayHasKey(Array, MultiDimKey*) {
    If !IsObject(Array)
        return
    For each, key in MultiDimKey {
        If !Array.HasKey(key)
            return false
        Array := Array[key]
    } return true
}

run(path){

    run % path
    return
}