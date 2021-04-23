package chap9.SegmentTree.example4.SegmentTreeProblemsInLeetcode;

public interface Merger<E> {
    E merge(E a, E b);
}
