export function filterPRs(prs, query) {
    if (!query.trim()) {
        return prs;
    }
    const lowerQuery = query.toLowerCase().trim();
    const tokens = parseFilterTokens(lowerQuery);
    return prs.filter(pr => {
        for (const token of tokens) {
            if (!matchesToken(pr, token)) {
                return false;
            }
        }
        return true;
    });
}
function parseFilterTokens(query) {
    const tokens = [];
    const parts = query.match(/(?:[^\s"]+|"[^"]*")+/g) || [];
    for (const part of parts) {
        const cleanPart = part.replace(/"/g, '');
        const negate = cleanPart.startsWith('-');
        const value = negate ? cleanPart.substring(1) : cleanPart;
        if (value.startsWith('repo:')) {
            tokens.push({ type: 'repo', value: value.substring(5), negate });
        }
        else if (value.startsWith('status:')) {
            tokens.push({ type: 'status', value: value.substring(7), negate });
        }
        else if (value.startsWith('stack:')) {
            tokens.push({ type: 'stack', value: value.substring(6), negate });
        }
        else if (value.startsWith('checks:')) {
            tokens.push({ type: 'checks', value: value.substring(7), negate });
        }
        else if (value.startsWith('review:')) {
            tokens.push({ type: 'review', value: value.substring(7), negate });
        }
        else if (value === 'restack' || value === 'needs-restack') {
            tokens.push({ type: 'stack', value: 'restack', negate });
        }
        else if (value === 'conflicts' || value === 'conflicting') {
            tokens.push({ type: 'merge', value: 'conflicts', negate });
        }
        else if (/^\d+$/.test(value)) {
            tokens.push({ type: 'number', value, negate });
        }
        else {
            tokens.push({ type: 'text', value, negate });
        }
    }
    return tokens;
}
function matchesToken(pr, token) {
    let matches = false;
    switch (token.type) {
        case 'text':
            matches = pr.title.toLowerCase().includes(token.value) ||
                pr.repository.name.toLowerCase().includes(token.value) ||
                pr.repository.fullName.toLowerCase().includes(token.value);
            break;
        case 'repo':
            matches = pr.repository.name.toLowerCase().includes(token.value) ||
                pr.repository.fullName.toLowerCase().includes(token.value);
            break;
        case 'number':
            matches = pr.number.toString() === token.value;
            break;
        case 'status':
            if (token.value === 'draft') {
                matches = pr.isDraft;
            }
            else if (token.value === 'open') {
                matches = pr.state === 'open';
            }
            else if (token.value === 'closed') {
                matches = pr.state === 'closed';
            }
            else if (token.value === 'merged') {
                matches = pr.state === 'merged';
            }
            break;
        case 'stack':
            if (token.value === 'yes' || token.value === 'true') {
                matches = pr.stack?.hasStack || false;
            }
            else if (token.value === 'restack') {
                matches = pr.stack?.needsRestack || false;
            }
            else {
                matches = !pr.stack?.hasStack;
            }
            break;
        case 'checks':
            if (token.value === 'failed' || token.value === 'failure') {
                matches = pr.status?.state === 'failure';
            }
            else if (token.value === 'passing' || token.value === 'success') {
                matches = pr.status?.state === 'success';
            }
            else if (token.value === 'pending') {
                matches = pr.status?.state === 'pending';
            }
            else if (token.value === 'none') {
                matches = !pr.status || pr.status.totalCount === 0;
            }
            break;
        case 'review':
            if (token.value === 'approved') {
                matches = pr.reviewStatus?.status === 'approved';
            }
            else if (token.value === 'changes' || token.value === 'changes_requested') {
                matches = pr.reviewStatus?.status === 'changes_requested';
            }
            else if (token.value === 'needs_reviews' || token.value === 'needs_more_reviews') {
                matches = pr.reviewStatus?.status === 'needs_more_reviews';
            }
            else if (token.value === 'needs_reviewers' || token.value === 'needs_more_reviewers') {
                matches = pr.reviewStatus?.status === 'needs_more_reviewers';
            }
            break;
        case 'merge':
            if (token.value === 'conflicts') {
                matches = pr.mergeable === 'CONFLICTING';
            }
            break;
    }
    return token.negate ? !matches : matches;
}
