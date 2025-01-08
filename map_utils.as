function Values(m) {
    local ret = [];
    local keys = m.Keys();
    for (local i = 0; i < keys.length; i++) {
        ret.Add(m[keys[i]]);
    }
    return ret;
}
