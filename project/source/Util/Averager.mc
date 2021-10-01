class Averager {
    var sum = 0;
    var count = 0;

    function update(val) {
        sum += val;
        count += 1;
        return get();
    }

    function get() {
        return sum/count;
    }

    function reset() {
        sum = 0;
        count = 0;
    }
}