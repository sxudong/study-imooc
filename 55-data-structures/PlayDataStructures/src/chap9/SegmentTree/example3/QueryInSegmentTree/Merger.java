package chap9.SegmentTree.example3.QueryInSegmentTree;

public interface Merger<E> {
    E merge(E a, E b);
}
