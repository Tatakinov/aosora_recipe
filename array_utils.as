function Range(a, b) {
    local ret = [];
    if (a >= b) {
        print("a < bとなるように引数を設定してください。");
        a();
    }
    for (local i = a; i < b; i++) {
        ret.Add(i);
    }
    return ret;
}

function Shuffle(a) {
    local ret = [];
    for (local i = 0; i < a.length; i++) {
        ret.Add(a[i]);
    }
    for (local i = a.length; i > 0; i--) {
        local j = Random.GetIndex(0, i);
        local tmp = ret[i - 1];
        ret[i - 1] = ret[j];
        ret[j] = tmp;
    }
    return ret;
}

function IndexOf(a, b) {
    for (local i = 0; i < a.length; i++) {
        if (b.InstanceOf(Delegate)) {
            if (b(a[i])) {
                return i;
            }
        }
        else {
            if (a[i] == b) {
                return i;
            }
        }
    }
    return null;
}

function Reverse(a) {
    local ret = [];
    for (local i = a.length - 1; i >= 0; i--) {
        ret.Add(a[i]);
    }
    return ret;
}

function Take(a, n) {
    return Filter(a, |i, _, arg| { i < arg; }, n);
}

function Drop(a, n) {
    return Filter(a, |i, _, arg| { !(i < arg); }, n);
}

function Slice(a, begin, end) {
    return Take(Drop(a, begin), end - begin);
}

function SumBy(a, f, args) {
    local ret = null;
    for (local i = 0; i < a.length; i++) {
        ret += f(a[i], args);
    }
    return ret;
}

function Sum(a) {
    return SumBy(a, |v| { v; });
}

function Join(a, delim) {
    if (delim.IsNull()) {
        delim = "";
    }
    local ret = SumBy(a, |v, arg| { v.ToString() + arg; }, delim);
    if (ret.IsNull()) {
        return "";
    }
    return ret.Substring(0, ret.length - delim.length);
}

function DistinctBy(a, f) {
    if (a.length == 0) {
        return [];
    }
    local ret = [];
    local prev = a[0];
    local prev_factor = f(a[0]);
    for (local i = 1; i < a.length; i++) {
        local current = a[i];
        local current_factor = f(a[i]);
        if (prev_factor != current_factor) {
            ret.Add(prev);
            prev = current;
            prev_factor = current_factor;
        }
    }
    ret.Add(prev);
    return ret;
}

function Distinct(a) {
    return DistinctBy(a, |v| { v; });
}

// Merge Sort
function __SortInternal(a, begin, end, f) {
    if (end - begin <= 1) {
        return Slice(a, begin, end);
    }
    local half = ( (end + begin) / 2 ).Floor();
    local b = __SortInternal(a, begin, half, f);
    local c = __SortInternal(a, half, end, f);
    local b_i = 0, c_i = 0;
    local ret = [];
    while (b_i < b.length && c_i < c.length) {
        if (f(c[c_i], b[b_i])) {
            ret.Add(c[c_i]);
            c_i++;
        }
        else {
            ret.Add(b[b_i]);
            b_i++;
        }
    }
    if (b_i < b.length) {
        for (; b_i < b.length; b++) {
            ret.Add(b[b_i]);
        }
    }
    if (c_i < c.length) {
        for (; c_i < c.length; c_i++) {
            ret.Add(c[c_i]);
        }
    }
    return ret;
}

function SortBy(a, f) {
    if (a.length == 0) {
        return [];
    }
    if (f(a[0], a[0])) {
        print("同値の比較ではfalseを返すようにしてください。");
        return a(); // わざとエラーにする
    }
    return __SortInternal(a, 0, a.length, f);
}

function Sort(a) {
    return SortBy(a, |a, b| { a < b; });
}

function __CompareInternal(a, cond, f) {
    if (a.length == 0) {
        return null;
    }
    local minmax = f(0, a[0]);
    for (local i = 0; i < a.length; i++) {
        local result = f(i, a[i]);
        if (cond(minmax, result)) {
            minmax = result;
        }
    }
    return minmax;
}

function MaxBy(a, f) {
    return __CompareInternal(a, |a, b| { a < b; }, f);
}

function Max(a) {
    return MaxBy(a, |_, v| { v; });
}

function MinBy(a, f) {
    return __CompareInternal(a, |a, b| { a > b; }, f);
}

function Min(a) {
    return MinBy(a, |_, v| { v; });
}
