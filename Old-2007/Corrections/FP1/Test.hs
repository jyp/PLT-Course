

within eps (cons a (cons b rest))
        | abs(a-b) <= eps = b
        | otherwise = within eps (cons b rest)