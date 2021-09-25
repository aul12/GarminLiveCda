class ExponentialSmoothing {
    private var lastVal = null;
    private var filterWeight;

    function initialize(filterWeight) {
        self.filterWeight = filterWeight;
    }

    function update(val) {
        if (lastVal != null) {
            lastVal = lastVal * filterWeight + val * (1-filterWeight);
        } else {
            lastVal = val;
        }
    }

    function get() {
        return lastVal;
    }
}