describe 'Stack', ->
  it 'should be empty after creation', ->
    test_stack = new Stack
    expect(test_stack.isEmpty()).to.be.true

  it 'should be able to push and pop values', ->
    test_stack = new Stack
    test_data = [1, 'lock', {o: 'test', v: 5}]
    test_stack.push(val) for val in test_data
    expect(test_stack.isEmpty()).to.be.false
    popped_data = (test_stack.pop() until test_stack.isEmpty())
    expect(popped_data).to.be.eql test_data.reverse()
    expect(test_stack.isEmpty()).to.be.true

  it 'should return top value without popping it', ->
    test_stack = new Stack
    test_stack.push(1)
    expect(test_stack.top()).to.be.equal 1
    expect(test_stack.top()).to.be.equal 1
    expect(test_stack.isEmpty()).to.be.false
    expect(test_stack.pop()).to.be.equal 1
    expect(test_stack.isEmpty()).to.be.true
