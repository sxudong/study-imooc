package chap9.SegmentTree.example5.UpdateSingleElementInSegmentTree;

public interface Merger<E> {
    E merge(E a, E b);
}
