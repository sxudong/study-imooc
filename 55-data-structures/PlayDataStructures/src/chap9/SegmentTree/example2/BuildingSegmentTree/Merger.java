package chap9.SegmentTree.example2.BuildingSegmentTree;

/**
 * 合并，归并
 * @param <E>
 */
public interface Merger<E> {
    E merge(E a, E b);
}
