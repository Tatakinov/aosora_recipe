function Clone(obj) {
    if (obj.InstanceOf(Array)) {
        local ret = [];
        for (local i = 0; i < obj.length; i++) {
            ret.Add(Clone(obj[i]));
        }
        return ret;
    }
    if (obj.InstanceOf(Map)) {
        local ret = {};
        local keys = obj.Keys();
        for (local i = 0; i < keys.length; i++) {
            ret.Add(Clone(keys[i]), Clone(obj[keys[i]]));
        }
        return ret;
    }
    return obj;
}

function __ForeachInternal(obj, internal, f, args) {
    local suffix = "";
    if (obj.IsString()) {
        suffix = "String";
    }
    else if (obj.InstanceOf(Array)) {
        suffix = "Array";
    }
    else if (obj.InstanceOf(Map)) {
        suffix = "Map";
    }
    else {
        return obj;
    }
    local m = Reflection.Get("__ForeachInternal" + suffix);
    return m(obj, internal, f, args);
}

function __ForeachInternalString(s, internal, f, args) {
    local ret = "";
    for (local i = 0; i < s.length; i++) {
        ret = internal(ret, |dest, _, v| {
            dest += v;
            return dest;
        }, f, i, s.Substring(i, 1), args);
    }
    return ret;
}

function __ForeachInternalArray(a, internal, f, args) {
    local ret = [];
    for (local i = 0; i < a.length; i++) {
        ret = internal(ret, |dest, _, v| {
            dest.Add(v);
            return dest;
        }, f, i, a[i], args);
    }
    return ret;
}

function __ForeachInternalMap(m, f, args) {
    local ret = {};
    local keys = m.Keys();
    for (local i = 0; i < keys.length; i++) {
        ret = internal(ret, |dest, k, v| {
            dest[k] = v;
            return dest;
        }, f, keys[i], m[keys[i]], args);
    }
    return ret;
}

function Mapping(obj, f, args) {
    return __ForeachInternal(obj, |dest, add, f, k, v, args| {
        dest = add(dest, k, f(k, v, args));
        return dest;
    }, f, args);
}

function Filter(obj, f, args) {
    return __ForeachInternal(obj, |dest, add, f, k, v, args| {
        if (f(k, v, args)) {
            dest = add(dest, k, v);
        }
        return dest;
    }, f, args);
}

function Any(obj, f, args) {
    return Filter(obj, f, args).length > 0;
}

function Contain(obj, args) {
    return Any(obj, |_, v, arg| { v == arg; }, args);
}

function All(obj, f, args) {
    return obj.length == Filter(obj, f, args).length;
}
