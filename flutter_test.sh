if which genhtml >/dev/null; then
else
    echo genhtml does not exist
    echo run \"brew install genhtml\" to install
    exit 1
fi

if flutter test --coverage ; then
    genhtml coverage/lcov.info -o coverage/html -q
    echo coverage page generated at coverage/html/index.html
else
    echo "TEST FAILED"
    exit 1
fi
