class Matrix {
    private var data;
    private var m, n;

    function initialize(m, n) {
        self.m = m;
        self.n = n;
        self.data = new [m * n];

        for (var i=0; i<m; ++i) {
            for (var j=0; j<n; ++j) {
                set(i, j, 0);
            }
        }
    }

    function setVals(data) {
        if (data.size() != self.data.size()) {
            throw new BasicException("Dimensions can not change!");
        }
        self.data = data;
    }

    function rows() {
        return m;
    }

    function cols() {
        return n;
    }

    function at(i, j) {
        if (i < 0 || j < 0 || i >= m || j >= n) {
            throw new BasicException("Out of bounds (i=" + i + ", j=" + j + ", m=" + m + ", n=" + n + ")");
        }
        return data[i * n + j];
    }

    function set(i, j, val) {
        data[i * n + j] = val;
    }

    function transposed() {
        var result = new Matrix(n, m);
        for (var i=0; i<m; ++i) {
            for (var j=0; j<n; ++j) {
                result.set(j, i, at(i, j));
            }
        }
        return result;
    }

    function scaled(alpha) {
        var result = new Matrix(m, n);
        for (var i=0; i<m; ++i) {
            for (var j=0; j<n; ++j) {
                result.set(i, j, at(i, j) * alpha);
            }
        }
        return result;
    }

    function inverse() {
        if (m != n) {
            throw new BasicException("Matrix not square!");
        }

        var result = new Matrix(m, n);


        if (m == 2) {
            var det = at(0, 0) * at(1, 1) - at(0, 1) * at(1, 0);
            if (det == 0) {
                throw new BasicException("Matrix singular!");
            }

            result.setVals([
                at(1, 1), -at(0, 1),
                -at(1, 0), at(0, 0)
            ]);

            result = result.scaled(1/det);
        } else {
            throw new BasicException("Not implemented!");
        }
        return result;
    }
}


function mm(a, b) {
    if (!(a instanceof Matrix && b instanceof Matrix)) {
        throw new BasicException("A and B need to be matrices!");
    }
    if (a.cols() != b.rows()) {
        throw new BasicException("Inner dimensions do not match (a.cols()=" + a.cols() + ", b.rows()=" + b.rows() + ")");
    }
    var l = a.cols();

    var result = new Matrix(a.rows(), b.cols());
    for (var i=0; i<result.rows(); ++i) {
        for (var j=0; j<result.cols(); ++j) {
            for (var k=0; k<l; ++k) {
                result.set(i, j, result.at(i, j) + a.at(i, k) * b.at(k, j));
            }
        }
    }

    return result;
}

function add(a as Matrix, b as Matrix) {
    if (!(a instanceof Matrix && b instanceof Matrix)) {
        throw new BasicException("A and B need to be matrices!");
    }
    if (a.rows() != b.rows() || a.cols() != b.cols()) {
        throw new BasicException("Size do not match!");
    }

    var result = new Matrix(a.rows(), a.cols());

    for (var i=0; i<result.rows(); ++i) {
        for (var j=0; j<result.cols(); ++j) {
            result.set(i, j, a.at(i, j) + b.at(i, j));
        }
    }

    return result;
}
