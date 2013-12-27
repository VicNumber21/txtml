describe 'Queue', ->
  it 'should be empty after creation', ->
    test_queue = new Queue
    expect(test_queue.isEmpty()).to.be.true
    expect(test_queue.length()).to.be.equal 0

  it 'should be able to enqueue and dequeue values', ->
    test_queue = new Queue
    test_data = [1, 'lock', {o: 'test', v: 5}]
    test_queue.enqueue(val) for val in test_data
    expect(test_queue.isEmpty()).to.be.false
    expect(test_queue.length()).to.be.equal 3
    dequeued_data = (test_queue.dequeue() until test_queue.isEmpty())
    expect(dequeued_data).to.be.eql test_data
    expect(test_queue.isEmpty()).to.be.true
    expect(test_queue.length()).to.be.equal 0

  it 'should return the next value without dequeueing it', ->
    test_queue = new Queue
    test_queue.enqueue(1)
    expect(test_queue.length()).to.be.equal 1
    expect(test_queue.peek()).to.be.equal 1
    expect(test_queue.peek()).to.be.equal 1
    expect(test_queue.isEmpty()).to.be.false
    expect(test_queue.length()).to.be.equal 1
    expect(test_queue.dequeue()).to.be.equal 1
    expect(test_queue.isEmpty()).to.be.true
    expect(test_queue.length()).to.be.equal 0
